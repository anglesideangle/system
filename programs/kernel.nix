{ lib, llvmPackages, linuxPackages_latest }:
(linuxPackages_latest.override {
  inherit (llvmPackages) stdenv;

  extraMakeFlags = [
    "LLVM=1"
    "KCFLAGS+=-mtune=znver4"
    "KCFLAGS+=-march=znver4"
  ];

  structuredExtraConfig = with lib.kernel; {
    # Enable Clang LTO (Link Time Optimization)
    LTO_CLANG = yes;
    LTO_CLANG_THIN = yes;

    # Enable CFI (Control Flow Integrity) - requires LTO
    CFI_CLANG = yes;

    # Optional: Ensure dependencies for these are met (usually automatic, but good for clarity)
    # SHADOW_CALL_STACK is often paired with CFI on supported archs
  };

  # 4. Critical: Add LLVM tools to the build environment
  # We override the attributes to ensure clang/lld are present during the build
}).overrideAttrs(old: {
      nativeBuildInputs = (old.nativeBuildInputs or []) ++ [
        llvmPackages.clang
        llvmPackages.lld
        llvmPackages.llvm
        llvmPackages.bintools
      ];
    })
