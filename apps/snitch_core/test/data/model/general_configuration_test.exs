defmodule Snitch.Data.Model.GeneralConfigurationTest do
  use ExUnit.Case, async: true
  use Snitch.DataCase

  import Snitch.Factory

  alias Snitch.Data.Schema.{Image, GeneralConfiguration}
  alias Snitch.Data.Model.GeneralConfiguration, as: GCModel
  alias Snitch.Data.Model.Image, as: ImageModel
  alias Snitch.Core.Tools.MultiTenancy.Repo

  @img "test/support/image.png"
  @img_new "test/support/image_new.png"

  setup do
    valid_params = %{
      "name" => "store",
      "sender_mail" => "hello@aviabird.com",
      "frontend_url" => "https://abc.com",
      "backend_url" => "https://abc.com",
      "seo_title" => "store",
      "currency" => "USD",
      "hosted_payment_url" => "https://abc.com"
    }

    general_config = insert(:general_config)

    image_params = %{
      type: "image/png",
      filename: "3Lu6PTMFSHz8eQfoGCP3F.png",
      path: @img
    }

    invalid_params = %{
      "seo_title" => "store"
    }

    [
      valid_params: valid_params,
      invalid_params: invalid_params,
      image_params: image_params,
      general_config: general_config
    ]
  end

  describe "create general configuration" do
    test "successfully along with image", %{image_params: ip, valid_params: vp} do
      vp = vp |> Map.put("image", ip)
      assert {:ok, general_config} = GCModel.create(vp)
      path = Path.wildcard("uploads/images/**/#{general_config.id}/") |> List.first()
      cleanup(path)
    end

    test "successfully without image", %{valid_params: vp} do
      assert {:ok, general_config} = GCModel.create(vp)
    end

    test "with invalid params", %{invalid_params: ip} do
      assert {:error, _} = GCModel.create(ip)
    end
  end

  describe "update general configuration" do
    test "successfully along with image", %{image_params: ip, general_config: gc} do
      new_image = %{
        type: "image/png",
        filename: "3Lu6PTMFSHz8eQfoGCCCC.png",
        path: @img_new
      }

      gc = gc |> Repo.preload(:image)
      params = %{} |> Map.put("image", new_image)
      assert {:ok, general_config} = GCModel.update(gc, params)
      path = Path.wildcard("uploads/images/**/#{general_config.id}") |> List.first()
      cleanup(path)
    end

    test "successfully without image", %{general_config: gc} do
      params = %{"name" => "new_store"}
      assert {:ok, general_config} = GCModel.update(gc, params)
    end

    test "with invalid params", %{general_config: gc} do
      params = %{"name" => nil}
      assert {:error, _} = GCModel.update(gc, params)
    end
  end

  defp cleanup(path) do
    File.rm_rf(path)
  end
end
