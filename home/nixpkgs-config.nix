{
  cudaSupport = true;
  allowUnfreePredicate =
    p:
    builtins.elem p.pname [
      "megasync"
    ]
    || builtins.all (
      license:
      license.free
      || builtins.elem license.shortName [
        "CUDA EULA"
        "cuDNN EULA"
      ]
    ) (p.meta.licenses or [ p.meta.license ]);
}
