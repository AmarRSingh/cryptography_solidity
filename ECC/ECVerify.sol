pragma solidity ^0.4.18;


library ECVerify {
     function ecverify(bytes32 hash, bytes signature) internal pure returns (address signature_address) {
          require(signature.length == 65);

          bytes32 r;
          bytes32 s;
          uint8 v;

          //The signature format is a compact form of
          // {bytes r}{bytes s}{uint8 v}
          // Compact means, uint8 is not padded to 32 bytes
          assembly {
               r := mload(add(signature, 32))
               s := mload(add(signature, 64))

               // Here we are loading at last 32 bytes, including 31 bytes of 's'.
               v := byte(0, mload(add(signature, 96)))
          }

          // Version of signature should be 27 or 28, but 0 and 1 are also possible
          if (v < 27) {
               v += 27;
          }

          require(v == 27 || v == 28);
          // (possible unnecessary arithmetic and change in representation from lines 23-18)

          signature_address = ecrecover(hash, v, r, s);

          //ecrecover returns zero on error
          require(signature_address != 0x0);

          return signature_address;
     }
}
