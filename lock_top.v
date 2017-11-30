module lock_top ();

//wires for connections between modules go here:

//this is a comment, and it's being modified

//instantiate modules
 Controller controller(.submit(), 
					.system_reset(), 
					.num_inputs(), 
					.compare_out(), 
					.reset(), 
					.pass_len(), 
					.out_hex()
					);
module code_checker( 
	.input_value(), //signal from Controller, store value in input register
	.store_value(), //signal from Controller, store value in system register
	.compare(), 	// activates compare operation on posedge compare
		.input_reset(), 
		.system_reset(), //two different reset signals from Controller
		.bits(), 
		.in_test0(), 
		.in_test1(), 
		.in_test2(), 
		.in_test3(), 
		.sys_test0(), 
		.sys_test1(), 
		.sys_test2(), 
		.sys_test3(),
		.correct_password(), 
		.incorrect_password() //result of compare operation
		);
					
code_checker c0();

setup_panel s0();

endmodule

