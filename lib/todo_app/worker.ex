defmodule TodoApp.Worker do
  require Axon

  def detect(binary) do
    tensor = preprocess(binary)
    {model, params} = AxonOnnx.import("model/squeezenet/model.onnx")

    Axon.predict(model, params, tensor)
    |> Nx.flatten()
    |> Nx.argsort()
    |> Nx.reverse()
    |> Nx.slice([0], [5])
    |> Nx.to_flat_list()
  end

  def preprocess(binary) do
    {:ok, image} = StbImage.from_binary(binary)
    {:ok, image} = StbImage.resize(image, 224, 224)

    StbImage.to_nx(image)
    |> Nx.divide(255)
    |> Nx.subtract(Nx.tensor([0.485, 0.456, 0.406]))
    |> Nx.divide(Nx.tensor([0.229, 0.224, 0.225]))
    |> Nx.transpose()
    |> Nx.new_axis(0)
  end
end
