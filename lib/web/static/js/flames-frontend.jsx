import React from 'react';
import {render} from 'react-dom';
import {Socket} from "phoenix";
import ErrorTable from './error-table.jsx';
import Error from './error.jsx';
import Layout from './layout.jsx';
import { Router, Route, useRouterHistory, IndexRoute, withRouter } from 'react-router';
import { createHashHistory } from 'history';

const appHistory = useRouterHistory(createHashHistory)({ queryKey: false })

class Main extends React.Component {
  static contextTypes: {
    router: React.PropTypes.object.isRequired
  }

  constructor(props) {
    super(props);

    let socket = new Socket(`${window.location.pathname}/socket`, {params: {token: window.token}});
    socket.connect();
    this.state = {socket: socket};
  }

  render () {
    return (
      <Layout>
        <ErrorTable socket={this.state.socket} router={this.props.router} search={this.state.search} />
      </Layout>
    );
  }
}

render(
  <Router history={appHistory}>
    <Route path="/" >
      <IndexRoute component={withRouter(Main)}/>
      <Route path="/errors/:id" component={Error} />
    </Route>
  </Router>
  , document.getElementById('app'));
