defmodule Chess.GameMasterTest do
  use ExUnit.Case

  alias Chess.{GameMaster, GameSession}

  @game_master_name :test_game_master

  setup do
    start_supervised!({GameMaster, [name: @game_master_name]})

    :ok
  end

  describe "start_game" do
    test "returns the name of the game" do
      name = GameMaster.start_game(@game_master_name, ["a", "b"])

      assert GameSession.exists?(name)
    end
  end
end
