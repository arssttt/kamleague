defmodule KamleagueWeb.PowMailer do
  use Pow.Phoenix.Mailer
  use Bamboo.Mailer, otp_app: :kamleague

  import Bamboo.Email

  @impl true
  def cast(%{user: user, subject: subject, text: text, html: html}) do
    new_email(
      to: user.email,
      from: "support@kamleague.com",
      subject: subject,
      html_body: html,
      text_body: text
    )
  end

  @impl true
  def process(email) do
    deliver_now(email)
  end
end
