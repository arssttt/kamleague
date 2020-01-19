defmodule KamleagueWeb.ResetPasswordController do
  use KamleagueWeb, :controller

  plug :load_user_from_reset_token when action in [:edit, :update]
  plug :assign_update_path when action in [:edit, :update]

  def new(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"user" => user_params}) do
    conn
    |> PowResetPassword.Plug.create_reset_token(user_params)
    |> case do
      {:ok, %{token: token, user: user}, conn} ->
        deliver_email(conn, user, token)

        conn
        |> put_flash(:info, "Check your email to reset password")
        |> redirect(to: Routes.reset_password_path(conn, :new))

      {:error, _changeset, conn} ->
        conn
        |> put_flash(:info, "Check your email to reset password")
        |> redirect(to: Routes.reset_password_path(conn, :new))
    end
  end

  def edit(conn, _params) do
    changeset = Pow.Plug.change_user(conn)

    render(conn, "edit.html", changeset: changeset)
  end

  def update(conn, %{"user" => user_params}) do
    conn
    |> PowResetPassword.Plug.update_user_password(user_params)
    |> case do
      {:ok, _user, conn} ->
        conn
        |> put_flash(:info, "Your password has been reset")
        |> redirect(to: Routes.login_path(conn, :new))

      {:error, changeset, conn} ->
        conn
        |> assign(:changeset, changeset)
        |> render("edit.html")
    end
  end

  defp load_user_from_reset_token(%{params: %{"id" => token}} = conn, _opts) do
    case PowResetPassword.Plug.user_from_token(conn, token) do
      nil ->
        conn
        |> put_flash(:error, "Invalid reset token")
        |> redirect(to: Routes.reset_password_path(conn, :new))
        |> halt()

      user ->
        PowResetPassword.Plug.assign_reset_password_user(conn, user)
    end
  end

  defp deliver_email(conn, user, token) do
    url = Routes.reset_password_url(conn, :edit, token)
    email = PowResetPassword.Phoenix.Mailer.reset_password(conn, user, url)

    Pow.Phoenix.Mailer.deliver(conn, email)
  end

  defp assign_update_path(conn, _opts) do
    token = conn.params["id"]
    path = Routes.reset_password_path(conn, :update, token)
    Plug.Conn.assign(conn, :action, path)
  end
end
