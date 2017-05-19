defmodule Flames.LoggerTest do
  use ExUnit.Case
  alias Flames.Logger, as: LogHandler
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

  def post_event(message \\ "zomg") do
    LogHandler.post_event(:error,
                          {Logger,
                          [message],
                          @datetime,
                          pid: self(), module: __MODULE__, fun: :some_fun, file: "somefile.ex", line: 12})
  end

end
