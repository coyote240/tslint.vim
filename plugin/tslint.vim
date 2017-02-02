if !exists("g:tslintprg")
	let g:tslintprg="tslint"
endif

function! s:TSLint(cmd, args)
	redraw

	if empty(a:args)
		let l:fileargs = expand("%")
	else
		let l:fileargs = a:args
	end

	let grepprg_bak = &grepprg
	let grepformat_bak = &grepformat

	try
		let &grepprg = g:tslintprg
		let &grepformat = "%f: line %l\\,\ col %c\\, %m,%-G,%-G%s error,%-G%s errors"
		let cmdline = [a:cmd]
		if exists("g:tslintconfig")
			call add(cmdline, '--config')
			call add(cmdline, g:tslintconfig)
		end
		call add(cmdline, l:fileargs)
		silent execute join(cmdline)
	finally
		let &grepprg=grepprg_bak
		let &grepformat=grepformat_bak
	endtry

	if len(getqflist()) > 0
		botright copen

		exec "nnoremap <silent> <buffer> q :ccl<CR>"
		exec "nnoremap <silent> <buffer> o <C-W><CR>"
		exec "nnoremap <silent> <buffer> go <CR><C-W><C-W>"

		redraw!
	else

		cclose
		redraw!
		echo "TSLint: Lint Free"

	end

endfunction

command! -bang -nargs=* -complete=file TSLint call s:TSLint('grep<bang>',<q-args>)
