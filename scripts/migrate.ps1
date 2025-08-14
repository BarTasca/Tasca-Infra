$ErrorActionPreference = 'Stop'

# Esperar a que MySQL esté healthy
Write-Host "Esperando a que MySQL esté healthy..."
$retries = 30
for ($i=0; $i -lt $retries; $i++) {
  $state = (docker inspect -f '{{.State.Health.Status}}' bar_tasca_mysql) 2>$null
  if ($state -eq 'healthy') { Write-Host "MySQL healthy"; break }
  Start-Sleep -Seconds 2
}
if ($state -ne 'healthy') {
  throw "MySQL no está healthy. Revisa 'docker logs bar_tasca_mysql'."
}

# Lanzar migraciones usando el startup project del backend
Push-Location ../BarTascaBackend
dotnet ef database update --project .\Data --startup-project .\BarTascaBackend
Pop-Location

Write-Host "Migraciones aplicadas correctamente."
