#------------------------------------------------------------------------------------
# BQN low-level function utils
#------------------------------------------------------------------------------------

# BQN Pointer functions
# neccesary for low level programming in bqn
MovePtr  ⇐ (256⋆↕8){-⟜(256×≥⟜128)256|⌊𝕗÷˜𝕨+´𝕗×256|𝕩} # bytes 𝕊 pointer # Move pointer by an amount of bytes

ReadI8   ⇐ {(𝕩.Cast "i8" ).WriteList 𝕨} # write data 𝕨 to pointer 𝕩
ReadI16  ⇐ {(𝕩.Cast "i16").WriteList 𝕨} # write data 𝕨 to pointer 𝕩
ReadI32  ⇐ {(𝕩.Cast "i32").WriteList 𝕨} # write data 𝕨 to pointer 𝕩
MakeI8   ⇐ {(𝕩.Cast "i8" ).ReadList 𝕨} # read 𝕨 numbers from pointer 𝕩
MakeI16  ⇐ {(𝕩.Cast "i16").ReadList 𝕨} # read 𝕨 numbers from pointer 𝕩
MakeI32  ⇐ {(𝕩.Cast "i32").ReadList 𝕨} # read 𝕨 numbers from pointer 𝕩
Read ⇐ ReadI8
Make ⇐ MakeI8

MakeUTF8 ⇐ •FromUTF8 MakeI8 # turn 𝕨-byte UTF-8-encoded string at pointer 𝕩 to BQN string
strLen   ⇐ @•FFI "i32"‿"strlen"‿">*:i8" # 𝕊 pointer # length of unicode C-string
ReadCharsTo0 ⇐ {•foreign.ReadCharsTo0 𝕩.Cast "i8"} # read null-terminated UTF-8-encoded string at 𝕩


null ⇐ •foreign.null
nullI8 ⇐ null.Cast "i8"
IsNull ⇐ {0 = nullI8.Sub 𝕩.Cast "i8"}

# NumCount 𝕊 pointer # turn data at pointer into a number array
MakeF32 ⇐ (@•FFI"*:i8"‿"memcpy"‿"⥊f32"‿"*i8"‿"usize"){1⊑𝔽 ⟨𝕨, 𝕩, 𝕨×4⟩}

F32ToI8 ⇐ (@•FFI"*:i8"‿"memcpy"‿"⥊i8"‿"*f32"‿"usize"){1⊑𝔽⟨4×≠𝕩, 𝕩, 4×≠𝕩⟩}


# Note, raylib.MemAlloc should be used as Alloc with raylib.
GetFnsNeedingAlloc ⇐ {𝕊alloc:
  ⟨ AllocCStr ⟩⇐

  # Returns pointer but also length because
  # length changes after converting to UTF8
  # and getting length from the output with
  # low.StrLen is O(n).
  # It is also a good reminder to not assume
  # input string length is the C-string length.
  AllocCStr ⇐ {𝕊str:
    p ← (Alloc 1+≠str).Cast "i8:c8"
    utfCStr ← @∾˜•ToUTF8 str
    len ← ≠utfCStr
    p.WriteList utfCStr∾@
    ⟨len-1, p⟩
  }
}
