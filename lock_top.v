module lock_top ();

//wires for connections between modules go here:

//this is a comment

//instantiate modules
 Controller controller(.submit(), 
					.system_reset(), 
					.num_inputs(), 
					.compare_out(), 
					.reset(), 
					.pass_len(), 
					.out_hex()
					);
					
code_checker c0();

setup_panel s0();

endmodule

