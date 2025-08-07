# -*- mode:powershell -*-

###########
# OPTIONS #
###########

Set-PSReadLineOption -EditMode Emacs

Set-PSReadLineOption -Colors @{
    Command            = 'Blue'
    Number             = 'DarkYellow'
    Member             = 'DarkMagenta'# functions/types
    Operator           = 'Black'
    Type               = 'DarkMagenta'
    Variable           = 'Cyan'
    Parameter          = 'Cyan'
    String             = 'DarkRed'
    Comment            = 'DarkGreen'
    ContinuationPrompt = 'DarkGray'
    Default            = 'Black'
}

#############
# FUNCTIONS #
#############

function vterm_printf($str) {
    Write-Host -NoNewline "`e]$str`a"
}

function vterm_prompt_end() {
    vterm_printf ("51;A{0}@{1}:{2}" -f $env:USER, $env:HOSTNAME, $PWD.PATH)
}

function prompt {
    return "PS {0}> {1}" -f $PWD.PATH, $(vterm_prompt_end)
}

function ec {
    $allArgs = @("--create-frame") + $args
    Start-Process emacsclient -ArgumentList $allArgs
}

function sys {
    $allArgs = @("--user") + $args
    systemctl @allArgs
}

function ls {
    $allArgs = @("--color", "--human-readable", "--indicator-style", "slash", "--file-type", "--group-directories-first") + $args
    /usr/bin/ls @allArgs
}

function jrn {
    $allArgs = @("--user", "--follow", "--unit") + $args
    journalctl @allArgs
}

function magit {
    emacsclient --tty --eval '(progn (magit default-directory) (delete-other-windows))'
}

function ip {
    /usr/sbin/ip $(@("-color") + $args)
}

function fd {
    Set-Location -Path "$(find . -type d | fzf)"
}

##########
# PROMPT #
##########

function prompt {
    Write-Host ""
    Write-Host "$env:USER" -NoNewline -ForegroundColor Cyan
    Write-Host "@" -NoNewline -ForegroundColor DarkGray
    Write-Host "$(Get-Content -Path '/proc/sys/kernel/hostname')" -NoNewline -ForegroundColor Green
    Write-Host " $($PWD.Path)" -NoNewline -ForegroundColor Yellow
    Write-Host "`n" -NoNewline -ForegroundColor White
    return 'PS> '
}

############
# EPILOGUE #
############

if (Test-Path -Type Leaf -Path "$env:HOME/.profile.local.ps1") {
    . "$env:HOME/.profile.local.ps1"
}
