/*************************************************************************************************
* file: code-conversion.s (Lab Assingment-5)                                                     *
* Author: Jethin Sekhar R (CS18M523)                                                             *
* Assembly code for Character-Coded Data                                                         *
*    Part 1: Convert the contents of a given A_DIGIT variable from an ASCII character to a       *
*            hexadecimal digit and store the result in H_DIGIT                                   *
*    Part 2: Convert a given eight ASCII characters in the variable STRING to an 8-bit binary    *
*            number in the variable NUMBER.                                                      *
*    Part 3: Convert a given eight-digit packed binary-coded-decimal number in the BCDNUM        *
*            variable into a 32-bit number in a NUMBER variable.                                 *
*************************************************************************************************/
@ bss section
    .bss

@ data section
    .data

    part1_input:          .asciz    "0123456789ABCDEFabcdefghiXYZ-+/*!@#12345"
    part2_input1:         .asciz    "11010010"
    part2_input2:         .asciz    "11010710"
    .ALIGN 4
    part3_input:          .word     0x92529679
                                                    @ Part1 Test Result
    .ALIGN 4
    result_start:         .asciz    "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
                          .asciz    "UUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUUU"
                                                    @ Part2 Test Result
    .ALIGN 4
    result_part2:         .byte     0x00, 0x00, 0x00, 0x00
                                                    @ Part3 Test Result
    .ALIGN 4
    result_part3:         .word     0x00
@ text section
      .text

@Function : CompareString                           @ Accepts 3 params and compares for fixed length
.global _fnCompareString                            @ Param1 : String1
                                                    @ Param2 : String2
                                                    @ Param3 : Length
                                                    @ Return : Greater(0xFFFFFFFF) or Not(0x00000000)

@Function : FindSubString                           @ Accepts 2 params and finds substring
.global _fnFindSubString                            @ Param1 : String1
                                                    @ Param2 : String2
                                                    @ Return : Sub String Index, 0 if not found

@ Globals Defines for Functions
retVal               .req r0                        @ Return Value
param1               .req r1                        @ Function Param1
param2               .req r2                        @ Function Param2
param3               .req r3                        @ Function Param3
param4               .req r4                        @ Function Param4
temp                 .req r8                        @ Temporary Variable
temp1                .req r8                        @ Temporary Variable
temp2                .req r9                        @ Temporary Variable

.global _main
    bl _main

/*** Function Declarations **********************************************************************/
.global _fnAsciitoHex                               @ Convert Ascii to Hex
.global _fnAsciitoBin                               @ Convert Ascii to Binary
.global _fnStringtoBin                              @ Convert Ascii String to Hex(Binary)
.global _fnBCDtoHEX                                 @ Convert BCD to Hex
.global _fnStoreResult                              @ Store word data to result
.global _fnStoreResultb                             @ Store byte data to result

/*** main Function ******************************************************************************/
result_store_idx     .req r10                       @ Index for result Store
value_idx            .req r11                       @ Index for Values
_main:                                              @
/*** Part 1: Convert to Hex *********************************************************************/
                                                    @ Convert to Hex
    mov  result_store_idx, #0                       @ Intialize local variables
    mov  value_idx, #0                              @
    ldr  param2, =part1_input                       @
  _part1_loop:                                      @ Loop to itterate over string
    ldrb param1, [param2, value_idx]                @    till end of the string
    movs param1, param1                             @
    beq  _part1_end                                 @
    bl   _fnAsciitoHex                              @ Convert to Hex
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @
    add  value_idx, #1                              @
    b    _part1_loop                                @
  _part1_end:                                       @

/*** Part 2_prework: Convert to Binary ***********************************************************/
                                                    @ Convert to Binary
    ldr  param2, =part2_input1                      @ Intialize local variables
    mov  value_idx, #0                              @
  _part2_1_loop:                                    @ Loop to itterate over string
    ldrb param1, [param2, value_idx]                @    till end of the string
    movs param1, param1                             @
    beq  _part2_1_end                               @
    bl   _fnAsciitoBin                              @ Convert to Hex
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @
    add  value_idx, #1                              @
    b    _part2_1_loop                              @
  _part2_1_end:                                     @

/*** Part 2_prework: Convert to Binary ***********************************************************/
                                                    @ Convert to Binary
    ldr  param2, =part2_input2                      @ Intialize local variables
    mov  value_idx, #0                              @
  _part2_2_loop:                                    @ Loop to itterate over string
    ldrb param1, [param2, value_idx]                @    till end of the string
    movs param1, param1                             @
    beq  _part2_2end                                @
    bl   _fnAsciitoBin                              @ Convert to Hex
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @
    add  value_idx, #1                              @
    b    _part2_2_loop                              @
  _part2_2end:                                      @

/*** Part 2 Test A: Convert to Binary ***********************************************************/
                                                    @ Convert Binary String to Hex
    ldr  param1, =result_start                      @ Initialize local Variables
    ldr  result_store_idx, =result_part2            @    pointer to string and result
    sub  result_store_idx, param1                   @
    ldr  param1, =part2_input1                      @
    bl   _fnStringtoBin                             @ Convert Binary to Hex
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @
    mov   retVal, param2                            @ Move Param2(Second Output to retVal)
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @

/*** Part 2 Test B: Convert to Binary ***********************************************************/
                                                    @ Convert Binary String to Hex
    ldr  param1, =part2_input2                      @ Initialize local Variables
    bl   _fnStringtoBin                             @ Convert Binary String to Hex
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @
    mov   retVal, param2                            @ Move Param2(Second Output to retVal)
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResultb                            @    Result Store Index
    add  result_store_idx, #1                       @

/*** Part 2 Test B: Convert to BCD to HEX *******************************************************/
                                                    @ Convert BCD to Hex
    ldr  param1, =result_start                      @ Initialize local Variables
    ldr  result_store_idx, =result_part3            @    value and result
    sub  result_store_idx, param1                   @
    ldr  param1, =part3_input                       @
    ldr  param1, [param1]                           @
    bl   _fnBCDtoHEX                                @ Convert BCD to Hex
    mov   param1, result_store_idx                  @ Store the Result and increment
    bl   _fnStoreResult                             @    Result Store Index
    add  result_store_idx, #1                       @
                                                    @
    bl   _end_of_program                            @ End of the program is here

/*** Function: AsciitoHex ***********************************************************************
* Convert the contents of a given A_DIGIT variable from an ASCII character to a hexadecimal     *
* digit and store the result in H_DIGIT. Assume that A_DIGIT contains the ASCII representation  *
* of a hexadecimal digit (i.e., 7 bits with MSB=0)                                              *
************************************************************************************************/
_fnAsciitoHex   :                                   @ Find SubString Index
    push  {param1, lr}                              @ Store local variables & return address to stack
    @ldrb  param1, [param1]                         @
    bl    _fncheckforHexDigit                       @
    movs  retVal, retVal                            @
    bpl   _fnAsciitoHex_end                         @
    movs  retVal, #0xFF                             @
  _fnAsciitoHex_end:                                @
    pop   {param1, pc}                              @ Restore all values and return

/*** Function: StringtoBin ***********************************************************************
* Convert a given eight ASCII characters in the variable STRING to an 8-bit binary number in the*
* variable NUMBER. Clear the byte variable ERROR if all the ASICC characters are either ASCII   *
* “1” or ASCII “0”; otherwise set ERROR to all ones (0xFF).                                     *
************************************************************************************************/
str_Idx             .req r4                         @ Index String1
_fnStringtoBin   :                                  @ Find SubString Index
    push  {param1, lr}                              @ Store local variables & return address to stack
    push  {str_Idx, temp1, temp2}                   @ Store local variables in stack
    mov   str_Idx, #-1                              @
    mov   retVal, #0                                @
    mov   param2, #0                                @
    mov   temp2, #0                                 @
    mov   temp1, param1                             @
  _fnStringtoBin_continue:                          @ Loop to itterate over string till end of string
    add   str_Idx, #1                               @
    ldrb  param1, [temp, str_Idx]                   @
    movs  param1, param1                            @
    beq   _fnStringtoBin_end                        @
    mov   temp2, temp2, LSL #1                      @ Multiply by 2 the entire number
    bl    _fncheckforBinDigit                       @ Check for Binary Digit otherwise error
    movs  retVal, retVal                            @
    bmi   _fnStringtoBin_error                      @
    add   temp2, retVal                             @
    b     _fnStringtoBin_continue                   @
  _fnStringtoBin_error:                             @
    movs  param2, #0xFF                             @
    movs  temp2, #0x00                              @
  _fnStringtoBin_end:                               @
    movs  retVal, temp2                             @
    pop   {str_Idx, temp1, temp2}                   @ Store local variables
    pop   {param1, pc}                              @ Restore all values and return


/*** Function: BCDtoHEX *************************************************************************
* Convert a given eight-digit packed binary-coded-decimal number in the BCDNUM variable into a  *
* 32-bit number in a NUMBER variable.                                                           *
************************************************************************************************/
_fnBCDtoHEX:                                        @ Find SubString Index
    push  {param1, lr}                              @ Store local variables & return address to stack
    push  {param2, temp1, temp2}                    @ Store local variables
    mov   retVal, #0                                @
    mov   temp2, #1                                 @
    mov   param2, #10                               @
  _fnBCDtoHEX_continue:                             @
    movs  temp1, param1                             @
    beq   _fnBCDtoHEX_end                           @
    and   temp1, #0x0F                              @
    mla   retVal, temp1, temp2, retVal              @
    mul   temp2, temp2, param2                      @
    movs  param1, param1, LSR #4                    @
    b     _fnBCDtoHEX_continue                      @
  _fnBCDtoHEX_end:                                  @
    pop   {param2, temp1, temp2}                    @ Store local variables
    pop   {param1, pc}                              @ Restore all values and return

/*** Function: AsciitoBin ***********************************************************************
* Convert a given ASCII characters in the variable to an 8-bit binary number in the variable    *
* NUMBER. set ERROR to all ones (0xFF).                                                         *
************************************************************************************************/
_fnAsciitoBin   :                                   @ Find SubString Index
    push  {param1, lr}                              @ Store local variables & return address to stack
    @ldrb  param1, [param1]                         @
    bl    _fncheckforBinDigit                       @
    movs  retVal, retVal                            @
    bpl   _fnAsciitoBin_end                         @
    movs  retVal, #0xFF                             @
  _fnAsciitoBin_end:                                @
    pop   {param1, pc}                              @ Restore all values and return

/*** Function: checkforHexDigit *****************************************************************/
_fncheckforHexDigit:                                @ Check the digit is hex or not and convert
    push  {temp, lr}
    mov   temp, param1
    subs  temp, #'0'
    bmi   _fncheckforHexDigit_notHex
    mov   retVal, temp
    subs  temp, #0x0A
    bmi   _fncheckforHexDigit_retValue
    mov   temp, param1
    bic   temp, #0x20
    subs  temp, #'A'
    bmi   _fncheckforHexDigit_notHex
    mov   retVal, temp
    add   retVal, #0x0A
    subs  temp, #0x06
    bmi   _fncheckforHexDigit_retValue
  _fncheckforHexDigit_notHex:
    mov   retVal, #0
    subs  retVal, #1
  _fncheckforHexDigit_retValue:
    pop  {temp, pc}

/*** Function: checkforBinDigit *****************************************************************/
_fncheckforBinDigit:                                @ Check the digit is bin or not and convert
    push  {temp, lr}
    mov   temp, param1
    subs  temp, #'0'
    bmi   _fncheckforBinDigit_notBin
    mov   retVal, temp
    subs  temp, #0x02
    bmi   _fncheckforBinDigit_retValue
  _fncheckforBinDigit_notBin:
    mov   retVal, #0
    subs  retVal, #1
  _fncheckforBinDigit_retValue:
    pop  {temp, pc}

/*** Function: storeResult **********************************************************************/
_fnStoreResult:                                     @ Store Result, Recevies Index and retVal
    push  {temp, lr}
    ldr   temp, =result_start
    str   retVal, [temp, param1]
    pop   {temp, pc}

/*** Function: storeResultByte********************************************************************/
_fnStoreResultb:                                    @ Store Result, Recevies Index and retVal
    push  {temp, lr}
    ldr   temp, =result_start
    strb  retVal, [temp, param1]
    pop   {temp, pc}

/*** End ****************************************************************************************/
_end_of_program:
    .end