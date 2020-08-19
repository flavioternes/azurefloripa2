Param(
 [string]$VMName,
 [string]$ResourceGroupName
)
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
# Iniciando a VM, utilizando as variáveis com os parâmetros que foram inseridos
Start-AzVM -Name $VMName -ResourceGroupName $ResourceGroupName

# Aplicando Tags de Localidade

$tags = @{Localidade="Floripa-SC"}

Set-AzResource -ResourceGroupName $ResourceGroupName -Name $VMName -ResourceType "Microsoft.Compute/VirtualMachines" -Tag $tags -Force
