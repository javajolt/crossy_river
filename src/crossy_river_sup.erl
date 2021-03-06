%%%-------------------------------------------------------------------
%% @doc crossy_river top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(crossy_river_sup).

-behaviour(supervisor).

%% API
-export([start_link/0]).

%% Supervisor callbacks
-export([init/1]).

-define(SERVER, ?MODULE).

%%====================================================================
%% API functions
%%====================================================================

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).

%%====================================================================
%% Supervisor callbacks
%%====================================================================

%% Child :: {Id,StartFunc,Restart,Shutdown,Type,Modules}
-spec(init(Args :: term()) ->
    {ok, {SupFlags :: {RestartStrategy :: supervisor:strategy(),
        MaxR :: non_neg_integer(), MaxT :: pos_integer()},
        [ChildSpec :: supervisor:child_spec()]
    }} |
    ignore).
init([]) ->
    RestartStrategy = one_for_one,
    MaxRestarts = 1000,
    MaxSecondsBetweenRestarts = 3600,

    SupFlags = {RestartStrategy, MaxRestarts, MaxSecondsBetweenRestarts},

    Restart = temporary, %% Don't bother to restart. It's just a game.
    Shutdown = 1000,
    Type = worker,

    Worker = {crossy_river_id, {crossy_river_statem, start_link, []},
        Restart, Shutdown, Type, [crossy_river_statem]},

    {ok, {SupFlags, [Worker]}}.

%%====================================================================
%% Internal functions
%%====================================================================
