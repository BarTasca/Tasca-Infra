param([switch]$Rebuild)
if ($Rebuild) { docker compose build --no-cache }
docker compose up -d
