const STREAMS = Dict{DataType,Dict{Int,Vector}}(
    UInt64 => Dict(
        0 => [0x45a31efc5a35d971, 0xc6106997913e7a3b, 0x949e7d1a64224226,
              0x233c600f92647349, 0x275e265b37c53f51, 0x7eb1431760d5e0d9,
              0x75a91e49d501684d, 0x2eb2f990c5bd12e0, 0xdf459aadbb8c0b08,
              0xcb81434944438ad0, 0x5385088560aef3b0, 0x0702607d43845765],
        1 => [0xd0e95cf50ea18c53, 0x52313cc6b3bb6eb2, 0xbddb774f2c66c674,
              0x69b5202eb72d59db, 0x761a7311a74fbdf5, 0x7c13c9462281a28d,
              0x60fb5add7f0438e8, 0x8c18ecb2513738a0, 0x9dd0d00932a42118,
              0x6283c9dbcccaa072, 0xfa8f1990220cdb11, 0x15072177ca8d0630],
        2^32 => [0xfa0ed1dea67579f2, 0xe88d5e0e5b8b40fe, 0x5ce30167dd0c0c22,
                 0x480546a1a865a818, 0x96e8a4ff013c8a92, 0x405d04cb572b978f,
                 0x1fabeee4affbf0c3, 0xba2d1f50e67a63d0, 0x565db0bdf8d96d6b,
                 0x540858ead6088e6d, 0x14e2efe6ac5775fa, 0x8e0b0f48316d364b],
        typemax(Int64) =>
        [0xe07cb1442060b16b, 0x9f15f9ca1910888d, 0x27d667e3a5597f5e,
         0xe7c43a5819b14e87, 0xbd5d7f453bf3bc1b, 0x7c7998438141ee3f,
         0xf7d425f171d5da47, 0xe1abaee77149b9c0, 0x3f6116840ff765f4,
         0xfd613e850d5b6198, 0x524f389f5079bcf4, 0x6ff20ef5be83190b])
)
