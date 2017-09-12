import React, { Component } from 'react';
import {Link} from 'react-router';
import Layout from './layout.jsx';
import ResolveButton from './resolve-button.jsx';
import moment from 'moment-timezone';
moment.tz.guess();

class Error extends Component {

  constructor(props) {
    super(props);
    this.state = {error: {}};
    $.get({
      url: `${window.location.pathname}/api/errors/${this.props.routeParams.id}`, dataType: 'json'
    }).done((data)=>{
      this.setState({error: data.error});
    }).fail(()=>{
      this.setState({failure: true});
    });
  }

  incidentTimestamp(timestamp) {
    return moment(timestamp).format('MMMM Do YYYY, h:mm:ss a');
  }

  render() {
    const { incidents, module, line, file } = this.state.error;
    const func = this.state.error['function'];
    let moduleLine = null;
    if(module && func && file && line) {
      moduleLine = (
        <span>
          <h5>{func}</h5>
          <h6>{file}:{line}</h6>
        </span>
      )
    }
    return (
      <Layout>
        <div className="row" id="error">
          <div className="col-xs-12">
            <Link to="/" className="btn">≪ Back</Link>
            <div className="pull-right">
              <ResolveButton className="btn-md" error={this.state.error} removeError={()=> { this.props.router.push('/'); } } />
            </div>
          </div>
        </div>
        <div className="row">
          <span>
            Last occurance: {this.incidentTimestamp(incidents && incidents[0] && incidents[0].timestamp || this.state.error.timestamp)}
          </span>
          {moduleLine}
          <pre>
            {this.state.error.message}
          </pre>
        </div>
      </Layout>
    );
  }
}

export default Error;
