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

  describe "#hash" do
    @error_with_map_data """
    Task #PID<0.2136.0> started from #PID<0.2135.0> terminating
    ** (stop) exited in: GenServer.call(#PID<0.1406.0>, :fetch, 5000)
        ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
        (elixir) lib/gen_server.ex:737: GenServer.call/3
        (slack_coder) lib/slack_coder/github/event_processor.ex:29: SlackCoder.Github.EventProcessor.process/2
        (elixir) lib/task/supervised.ex:85: Task.Supervised.do_apply/2
        (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
    Function: &SlackCoder.Github.EventProcessor.process/2
        Args: [:push, %{"after" => "66459fcbbc256e2d9d84cd42913fdbc5bac9677f", "base_ref" => nil, "before" => "dab0469b49190a3e90693e64c18cd615bb5791e7"}]
    """
    @error_with_map_data2 """
    Task #PID<0.1821.0> started from #PID<0.1820.0> terminating
    ** (stop) exited in: GenServer.call(#PID<0.1406.0>, :fetch, 5000)
        ** (EXIT) no process: the process is not alive or there's no process currently associated with the given name, possibly because its application isn't started
        (elixir) lib/gen_server.ex:737: GenServer.call/3
        (slack_coder) lib/slack_coder/github/event_processor.ex:29: SlackCoder.Github.EventProcessor.process/2
        (elixir) lib/task/supervised.ex:85: Task.Supervised.do_apply/2
        (stdlib) proc_lib.erl:247: :proc_lib.init_p_do_apply/3
    Function: &SlackCoder.Github.EventProcessor.process/2
        Args: [:push, %{"after" => "dab0469b49190a3e90693e64c18cd615bb5791e7", "base_ref" => nil, "before" => "466c92fb6b6e760a3e8309c2bfaa5b6a3884ffcc"}]
    """
    test "ignores maps" do
      assert LogHandler.hash(@error_with_map_data) == LogHandler.hash(@error_with_map_data2)
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
