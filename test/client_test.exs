defmodule Exgit.ClientTest do
  use ExUnit.Case

  import Tesla.Mock

  describe "get_repos_by_username/1" do
    test "when the user has repos, returns the repos" do

      username = "matheusheck"

      response = [
        %{"id" => 1, "name" => "my repo 1"},
        %{"id" => 2, "name" => "my repo 2"}
      ]

      expected_response = {:ok, response}

      mock(fn %{method: :get, url: "https://api.github.com/users/matheusheck/repos"} ->
        %Tesla.Env{status: 200, body: response}
      end)

      assert Exgit.Client.get_repos_by_username(username) == expected_response
    end

    test "when the user was not found, returns an error" do

      username = "matheusheck"

      expected_response = {:error, "User not found"}

      mock(fn %{method: :get, url: "https://api.github.com/users/matheusheck/repos"} ->
         %Tesla.Env{status: 404, body: ""}
      end)

      assert Exgit.Client.get_repos_by_username(username) == expected_response
    end
  end
end
