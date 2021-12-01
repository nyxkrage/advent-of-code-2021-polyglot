hello.fasl: 
	sbcl --noinform --eval "(compile-file \"hello.cl\")" --eval "(quit)" > /dev/null

run: hello.fasl
	sbcl --noinform --load "hello.fasl" --quit --end-toplevel-options "$@"
