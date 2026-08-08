inputs: system:
let
  extra-container = (
    self: prev: {

      extra-container = inputs.extra-container.packages.${system}.default;
    }
  );
in
[
  extra-container
]
