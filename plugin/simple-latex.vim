" Guard against multiple loading
if exists('g:loaded_simplelatex')
  finish
endif
let g:loaded_simplelatex = 1

" Key mapping
nnoremap <silent> <Leader>rl :call BuildAndOpenPDF()<CR>

function! BuildAndOpenPDF()
    " Save the current file if it has been modified
    if &modified
        write
    endif

    " Get the full path of the current file
    let l:texfile = expand('%:p')
    if l:texfile =~ '\.tex$'
        " Run pdflatex on the file, and show errors
        let l:cmd = 'pdflatex ' . shellescape(l:texfile, 1)
        execute '!' . l:cmd
        " Determine the PDF path (same name, .pdf extension)
        let l:pdffile = fnamemodify(l:texfile, ':r') . '.pdf'
        if filereadable(l:pdffile)
            " Open or refresh the PDF file in Okular, or refresh using unique
            let l:okularCmd = 'okular --unique ' . shellescape(l:pdffile, 1) . ' &'
            " execute opening okular silently, no messages in command line
            silent execute '!' . l:okularCmd
        else
            echo "PDF generation failed: no output file found."
        endif
    else
        echo "This is not a TeX file."
    endif
endfunction
