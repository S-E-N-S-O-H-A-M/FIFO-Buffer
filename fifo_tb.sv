// Description : Design of FIFO Buffer
// Owner : Soham Sen
// Date : 23/04/2026

module fifo_tb;
  
  // TB driving signals to DUT
  reg clock,reset,rd,wr;
  reg [7:0] data_in;
  
  // DUT output signals
  wire full,empty;
  wire [7:0] data_out;
  
  // DUT instantiation
  fifo f0(.clock(clock),
          .reset(reset),
          .wr(wr),
          .rd(rd),
          .data_in(data_in),
          .full(full),
          .empty(empty),
          .data_out(data_out));
  
  // Clock Generation
  always #5 clock = ~clock;
  
  // Initialization
  initial begin
    clock<=0;
    reset<=1;
    wr<=0;
    rd<=0;
    data_in<=0;
  end
  
  // Test Pattern
  initial begin
    // Reset Deactivation
    #10 reset=0;
    $display("Test Pattern 1 : Write to fill up the FIFO");
    // Test Pattern 1 : Write to fill up the FIFO
    for(integer i=0;i<32;i=i+1) begin
      #10;
      wr<=1;
      rd<=0;
      data_in<=$random();
    end
    $display("\n Test Pattern 2 : FIFO Full/ Overflow");
    // Test Pattern 2 : FIFO Full/ Overflow
    #10;
    wr<=1;
    rd<=0;
    data_in<=$random();
    #10;
    $display("\n Test Pattern 3 : Read from the FIFO");
    // Test Pattern 3 : Read from the FIFO
    for(integer i=0;i<32;i=i+1) begin
      #10;
      rd<=1;
      wr<=0;
    end
    $display("\n Test Pattern 4 : Fifo Empty/ Underflow");
    // Test Pattern 4 : Fifo Empty/ Underflow
    #10;
    rd<=1;
    wr<=0;
    #10;
    $display("\n Test Pattern 5 : Random");
    // Test Pattern 5 : Random
    for(integer i=0;i<32;i=i+1) begin
      #10;
      wr<=$random()%2;
      if(wr==1) begin
        rd<=0;
        data_in<=$random();
      end
      else begin
        rd<=1;
      end 
    end
    #10;
    $finish;
  end
  
  // Monitor the signals
  initial begin
    $monitor("[Time: %0t] :: reset=%0b wr=%0b rd=%0b data_in=%b full=%0b empty=%0b data_out=%b wr_ptr=%0d rd_ptr=%0d",$time,reset,wr,rd,data_in,full,empty,data_out,f0.wr_ptr,f0.rd_ptr);
  end
  
  // Dump the signals in the vcd file to be viewed in waveform
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end
  
endmodule
