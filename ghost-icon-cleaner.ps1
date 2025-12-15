<#
.SYNOPSIS
    Remove ícones fantasmas da área de trabalho no Windows.

.DESCRIPTION
    Este script aceita um nome de arquivo ou pasta como parâmetro e tenta
    remover o item caso exista. Se o item não existir, identifica que é
    um ícone fantasma e orienta a reinicialização do Explorer.

.PARAMETER Name
    Nome do arquivo ou pasta que aparece como ícone fantasma.

.EXAMPLE
    .\ghost-icon-cleaner.ps1 -Name "vaca-alegre"

.NOTES
    Autor: Cleiton da Costa Faria Santos
    Projeto: Ghost Icon Cleaner
#>

param(
    [Parameter(Mandatory = $true)]
    [string]$Name
)

# Caminho da área de trabalho
$desktopPath = [Environment]::GetFolderPath("Desktop")
$targetPath = Join-Path $desktopPath $Name

Write-Host "`n🔍 Verificando item: $Name" -ForegroundColor Cyan

# Verifica se o item realmente existe
if (Test-Path -LiteralPath $targetPath) {

    Write-Host "✅ Item encontrado: $targetPath" -ForegroundColor Green
    Write-Host "🔄 Tentando renomear para corrigir possíveis caracteres corrompidos..."

    # Nome temporário seguro
    $safeName = "ghost-temp-" + (Get-Random)

    Rename-Item -LiteralPath $targetPath -NewName $safeName -Force

    Write-Host "✅ Renomeado com sucesso para: $safeName" -ForegroundColor Green
    Write-Host "🗑️ Enviando para a lixeira via Shell.Application..."

    # Exclusão via COM Shell
    $shell = New-Object -ComObject Shell.Application
    $folder = $shell.Namespace($desktopPath)
    $item = $folder.ParseName($safeName)
    $item.InvokeVerb("delete")

    Write-Host "✅ Item enviado para a lixeira." -ForegroundColor Green

} else {
    Write-Host "⚠️ O item não existe no sistema de arquivos." -ForegroundColor Yellow
    Write-Host "✅ Isso confirma que é um ícone fantasma."
    Write-Host "🔄 Solução recomendada: Reiniciar o Windows Explorer."
}
