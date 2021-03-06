defmodule AdminAppWeb.DataExportMail do
  @moduledoc """
  Composing email to send order export.
  """

  import Swoosh.Email
  alias AdminAppWeb.Mailer
  alias Snitch.Data.Schema.GeneralConfiguration, as: GC
  alias Snitch.Core.Tools.MultiTenancy.Repo

  defp get_config do
    Repo.all(GC) |> List.first()
  end

  def data_export_mail(attachment, user, type) do
    sender_email = Application.get_env(:admin_app, AdminAppWeb.Endpoint)[:sendgrid_sender_mail]
    general_config = get_config
    store_name = general_config.name

    new()
    |> to(user.email)
    |> from({"#{store_name}", sender_email})
    |> subject("Your orders")
    |> text_body("Here is the #{type} export of your orders.")
    |> attachment(attachment)
    |> Mailer.deliver()
  end
end
