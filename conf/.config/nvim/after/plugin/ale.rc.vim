let g:ale_linters = {
\ 'php': ['php', 'phpcs', 'phpmd', 'psalm'],
\}
let g:ale_lint_on_enter=1
let g:ale_detail_to_floating_preview=1
let g:ale_hover_to_floating_preview=1
let g:ale_sign_error='☠'
let g:ale_sign_warning='ℹ'
let g:ale_hover_to_preview=1
let g:ale_completation_enable=1
let g:ale_floating_preview=1
let g:ale_echo_msg_error_str='E'
let g:ale_echo_msg_warning_str='W'
let g:ale_echo_msg_format='[%linter%] %s [%severity%]'
let g:ale_php_phpcs_standard='PSR2'
let g:ale_php_phpcs_options='--severity=1'
let g:ale_php_phpmd_ruleset='cleancode,codesize,controversial,design,unusedcode'

