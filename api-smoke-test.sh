#!/usr/bin/env bash
# Проверка доступа к GitHub API через PAT. Запускать команды по одной.
# Ничего не мутирует, КРОМЕ явно помеченных [WRITE] в конце.
#
# Настрой окружение:
export GH_TOKEN="ghp_xxx"                 # твой Personal Access Token
export GH_HOST="github.com"               # для Enterprise Server поменяй на хост
export REST="https://api.github.com"      # GHES: https://$GH_HOST/api/v3
export GRAPHQL="https://api.github.com/graphql"   # GHES: https://$GH_HOST/api/graphql
export OWNER="my-org"                      # владелец репозитория (организация)
export REPO="my-repo"                      # имя репозитория
export PR=1                                # номер PR для тестов чтения

AUTH=(-H "Authorization: Bearer $GH_TOKEN" \
      -H "Accept: application/vnd.github+json" \
      -H "X-GitHub-Api-Version: 2022-11-28" \
      -H "User-Agent: mygh-smoke/0.1")

# ─────────────────────────────────────────────────────────────
# 1. Токен жив? Кто я? Заодно смотрим scopes и SSO в ЗАГОЛОВКАХ ответа.
#    -i печатает заголовки. Важные:
#      X-OAuth-Scopes:            какие права у classic PAT (нужен repo)
#      X-GitHub-Sso:              признак того, что нужна SSO-авторизация токена
#    401 -> токен неверный/пустой.  200 -> токен валиден.
curl -i "${AUTH[@]}" "$REST/user"

# ─────────────────────────────────────────────────────────────
# 2. SSO-проверка: доступ к самой enterprise-организации.
#    Если PAT НЕ авторизован под SAML SSO, здесь будет 403 и заголовок
#    X-GitHub-SSO: required; url=https://github.com/orgs/<org>/sso?... (ссылка на авторизацию)
curl -i "${AUTH[@]}" "$REST/orgs/$OWNER"

# ─────────────────────────────────────────────────────────────
# 3. Доступ к репозиторию (200 -> есть права; 404 -> нет прав или SSO не пройден).
curl -i "${AUTH[@]}" "$REST/repos/$OWNER/$REPO"

# ─────────────────────────────────────────────────────────────
# 4. Список PR (чтение).
curl -s "${AUTH[@]}" "$REST/repos/$OWNER/$REPO/pulls?state=open&per_page=5"

# ─────────────────────────────────────────────────────────────
# 5. Inline review-комментарии PR через REST (без статуса resolved).
curl -s "${AUTH[@]}" "$REST/repos/$OWNER/$REPO/pulls/$PR/comments"

# ─────────────────────────────────────────────────────────────
# 6. GraphQL жив? viewer.login == твой аккаунт.
curl -s -H "Authorization: Bearer $GH_TOKEN" -H "User-Agent: mygh-smoke/0.1" \
  -X POST "$GRAPHQL" \
  -d '{"query":"query{ viewer { login } }"}'

# ─────────────────────────────────────────────────────────────
# 7. GraphQL: review-ТРЕДЫ со статусом isResolved + threadId (то, что нужно CLI).
curl -s -H "Authorization: Bearer $GH_TOKEN" -H "User-Agent: mygh-smoke/0.1" \
  -X POST "$GRAPHQL" \
  -d @- <<JSON
{"query":"query(\$owner:String!,\$repo:String!,\$number:Int!){repository(owner:\$owner,name:\$repo){pullRequest(number:\$number){reviewThreads(first:20){nodes{id isResolved isOutdated comments(first:5){nodes{databaseId author{login} path line body}}}}}}}",
 "variables":{"owner":"$OWNER","repo":"$REPO","number":$PR}}
JSON

# ═════════════════════════════════════════════════════════════
# [WRITE] Ниже — мутирующие вызовы. Запускай только осознанно.
# ═════════════════════════════════════════════════════════════

# 8. [WRITE] Создать PR (нужны существующие ветки head и base с разницей коммитов).
curl -i "${AUTH[@]}" -X POST "$REST/repos/$OWNER/$REPO/pulls" \
  -d '{"title":"smoke test PR","head":"feature-branch","base":"main","body":"created by api-smoke-test","draft":true}'

# 9. [WRITE] Обычный (не inline) комментарий к PR.
curl -i "${AUTH[@]}" -X POST "$REST/repos/$OWNER/$REPO/issues/$PR/comments" \
  -d '{"body":"smoke test comment"}'

# 10. [WRITE] Ответ в тред + резолв через GraphQL. Подставь THREAD_ID из шага 7 (поле id).
export THREAD_ID="PRRT_xxx"
curl -s -H "Authorization: Bearer $GH_TOKEN" -H "User-Agent: mygh-smoke/0.1" \
  -X POST "$GRAPHQL" \
  -d @- <<JSON
{"query":"mutation(\$id:ID!,\$body:String!){addPullRequestReviewThreadReply(input:{pullRequestReviewThreadId:\$id,body:\$body}){comment{url}}}",
 "variables":{"id":"$THREAD_ID","body":"reply from smoke test"}}
JSON

curl -s -H "Authorization: Bearer $GH_TOKEN" -H "User-Agent: mygh-smoke/0.1" \
  -X POST "$GRAPHQL" \
  -d @- <<JSON
{"query":"mutation(\$id:ID!){resolveReviewThread(input:{threadId:\$id}){thread{id isResolved}}}",
 "variables":{"id":"$THREAD_ID"}}
JSON


netsh winhttp show proxy
Get-ItemProperty "HKCU:\Software\Microsoft\Windows\CurrentVersion\Internet Settings" | Select ProxyServer, ProxyEnable, AutoConfigURL
