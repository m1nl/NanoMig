/*
 amiga_keymap_ebr.v

 EBR-friendly table to translate from FPGA Companion key codes into
 Amiga key codes. The incoming FPGA Companion codes are mainly the
 USB HID key codes with the modifier keys mapped into the 0x68+ range.

 Implemented as a synchronous ROM to allow inference as block RAM (EBR).
*/

module keymap (
  input            clk,
  input      [6:0] code,
  output reg [6:0] amiga
);

reg [6:0] mem [0:127] /* synthesis syn_ramstyle="block_ram" */;

integer i;
initial begin
  for (i = 0; i < 128; i = i + 1)
    mem[i] = 7'h7f;

  // characters
  mem[7'h04] = 7'h20; // a
  mem[7'h05] = 7'h35; // b
  mem[7'h06] = 7'h33; // c
  mem[7'h07] = 7'h22; // d
  mem[7'h08] = 7'h12; // e
  mem[7'h09] = 7'h23; // f
  mem[7'h0a] = 7'h24; // g
  mem[7'h0b] = 7'h25; // h
  mem[7'h0c] = 7'h17; // i
  mem[7'h0d] = 7'h26; // j
  mem[7'h0e] = 7'h27; // k
  mem[7'h0f] = 7'h28; // l
  mem[7'h10] = 7'h37; // m
  mem[7'h11] = 7'h36; // n
  mem[7'h12] = 7'h18; // o
  mem[7'h13] = 7'h19; // p
  mem[7'h14] = 7'h10; // q
  mem[7'h15] = 7'h13; // r
  mem[7'h16] = 7'h21; // s
  mem[7'h17] = 7'h14; // t
  mem[7'h18] = 7'h16; // u
  mem[7'h19] = 7'h34; // v
  mem[7'h1a] = 7'h11; // w
  mem[7'h1b] = 7'h32; // x
  mem[7'h1c] = 7'h15; // y
  mem[7'h1d] = 7'h31; // z

  // top number key row
  mem[7'h1e] = 7'h01; // 1
  mem[7'h1f] = 7'h02; // 2
  mem[7'h20] = 7'h03; // 3
  mem[7'h21] = 7'h04; // 4
  mem[7'h22] = 7'h05; // 5
  mem[7'h23] = 7'h06; // 6
  mem[7'h24] = 7'h07; // 7
  mem[7'h25] = 7'h08; // 8
  mem[7'h26] = 7'h09; // 9
  mem[7'h27] = 7'h0a; // 0

  // other keys
  mem[7'h28] = 7'h44; // return
  mem[7'h29] = 7'h45; // esc
  mem[7'h2a] = 7'h41; // backspace
  mem[7'h2b] = 7'h42; // tab
  mem[7'h2c] = 7'h40; // space

  mem[7'h2d] = 7'h0b; // -
  mem[7'h2e] = 7'h0c; // =
  mem[7'h2f] = 7'h1a; // [
  mem[7'h30] = 7'h1b; // ]
  mem[7'h31] = 7'h0d; // backslash
  mem[7'h32] = 7'h2b; // EUR-1
  mem[7'h33] = 7'h29; // ;
  mem[7'h34] = 7'h2a; // '
  mem[7'h35] = 7'h00; // `
  mem[7'h36] = 7'h38; // :
  mem[7'h37] = 7'h39; // .
  mem[7'h38] = 7'h3a; // /
  mem[7'h39] = 7'h62; // caps lock

  // function keys
  mem[7'h3a] = 7'h50; // F1
  mem[7'h3b] = 7'h51; // F2
  mem[7'h3c] = 7'h52; // F3
  mem[7'h3d] = 7'h53; // F4
  mem[7'h3e] = 7'h54; // F5
  mem[7'h3f] = 7'h55; // F6
  mem[7'h40] = 7'h56; // F7
  mem[7'h41] = 7'h57; // F8
  mem[7'h42] = 7'h58; // F9
  mem[7'h43] = 7'h59; // F10

  mem[7'h49] = 7'h5f; // Insert (also mapped to End)
  mem[7'h4a] = 7'h5a; // Home -> KP-(
  mem[7'h4b] = 7'h5b; // PageUp -> KP-)
  mem[7'h4c] = 7'h46; // Delete
  mem[7'h4d] = 7'h5f; // End -> HELP
  mem[7'h4e] = 7'h67; // PageDown -> Right-Amiga

  // cursor keys
  mem[7'h4f] = 7'h4e; // right
  mem[7'h50] = 7'h4f; // left
  mem[7'h51] = 7'h4d; // down
  mem[7'h52] = 7'h4c; // up

  // keypad
  mem[7'h54] = 7'h5c; // KP /
  mem[7'h55] = 7'h5d; // KP *
  mem[7'h56] = 7'h4a; // KP -
  mem[7'h57] = 7'h5e; // KP +
  mem[7'h58] = 7'h43; // KP Enter
  mem[7'h59] = 7'h1d; // KP 1
  mem[7'h5a] = 7'h1e; // KP 2
  mem[7'h5b] = 7'h1f; // KP 3
  mem[7'h5c] = 7'h2d; // KP 4
  mem[7'h5d] = 7'h2e; // KP 5
  mem[7'h5e] = 7'h2f; // KP 6
  mem[7'h5f] = 7'h3d; // KP 7
  mem[7'h60] = 7'h3e; // KP 8
  mem[7'h61] = 7'h3f; // KP 9
  mem[7'h62] = 7'h0f; // KP 0
  mem[7'h63] = 7'h3c; // KP .
  mem[7'h64] = 7'h2b; // EUR-2

  // remapped modifier keys
  mem[7'h68] = 7'h63; // left ctrl
  mem[7'h69] = 7'h60; // left shift
  mem[7'h6a] = 7'h64; // left alt
  mem[7'h6b] = 7'h66; // left meta
                       // right ctrl (unmapped)
  mem[7'h6d] = 7'h61; // right shift
  mem[7'h6e] = 7'h65; // right alt
  mem[7'h6f] = 7'h67; // right meta
end

always @(posedge clk)
  amiga <= mem[code];

endmodule
