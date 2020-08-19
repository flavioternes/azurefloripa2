# Garantir que você não herde um contexto diferente do ambiente atual
Disable-AzContextAutosave –Scope Process

$connection = Get-AutomationConnection -Name AzureRunAsConnection
while(!($connectionResult) -and ($logonAttempt -le 10))
{
    $LogonAttempt++
    # Logando no Azure...
    $connectionResult = Connect-AzAccount `
                            -ServicePrincipal `
                            -Tenant $connection.TenantID `
                            -ApplicationId $connection.ApplicationID `
                            -CertificateThumbprint $connection.CertificateThumbprint

    Start-Sleep -Seconds 30
}

Write-Output "################## Inicializando a máquina virtual azurefloripa2 ##################"
# Comando AZ de inicialização da VM
Start-AzVM -Name 'azurefloripa2' -ResourceGroupName 'AzureFloripa2'