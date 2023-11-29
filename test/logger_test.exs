defmodule Flames.LoggerTest do
  use ExUnit.Case
  alias Flames.Error.Worker, as: LogHandler
  alias Flames.Error

  describe "#post_event" do
    @datetime {{2017, 5, 19}, {2, 0, 7, 0}}
    test "inserts an error" do
      assert %Error{} = post_event()
    end

    test "broadcasts" do
      post_event()
      assert_receive({:broadcast, %Error{}})
    end
  end

  describe "#hash" do
    test "ignores maps" do
      assert LogHandler.hash(Fixtures.error_with_map_data_1()) ==
               LogHandler.hash(Fixtures.error_with_map_data_2())
    end

    test "strips large data" do
      assert LogHandler.strip_variable_data(Fixtures.large_error()) ==
               LogHandler.strip_variable_data(Fixtures.large_error_stripped())
    end

    test "similar messages produce the same hash" do
      assert LogHandler.hash(Fixtures.with_pid_1()) == LogHandler.hash(Fixtures.with_pid_2())
    end

    test "large message cut off at 4k" do
      assert LogHandler.hash(Messages.large_message_1() |> LogHandler.truncate_message()) ==
               LogHandler.hash(Messages.large_message_2() |> LogHandler.truncate_message())
    end
  end

  def post_event(message \\ "zomg") do
    LogHandler.handle_event(
      :error,
      {Logger, [message], @datetime,
       pid: self(), module: __MODULE__, fun: :some_fun, file: "somefile.ex", line: 12}
    )
  end
end
