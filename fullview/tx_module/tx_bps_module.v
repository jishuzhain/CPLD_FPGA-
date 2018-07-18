module tx_bps_module
(
    CLK, RSTn,
	 Count_Sig, 
	 BPS_CLK
);

    input CLK;
	 input RSTn;
	 input Count_Sig;
	 output BPS_CLK;
	 
	 /***************************/
	 
	 reg [15:0]Count_BPS;
	 
	 always @ ( posedge CLK or negedge RSTn )
	    if( !RSTn )
		     Count_BPS <= 16'd0;
		 else if( Count_BPS == 16'd20833 )
		     Count_BPS <= 16'd0;
		 else if( Count_Sig )
		     Count_BPS <= Count_BPS + 1'b1;
		 else
		     Count_BPS <= 16'd0;
			  
	 /********************************/

    assign BPS_CLK = ( Count_BPS == 16'd10416 ) ? 1'b1 : 1'b0;

    /*********************************/

endmodule

