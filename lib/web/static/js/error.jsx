import React from 'react';
import {Link} from 'react-router';
import Layout from './layout.jsx';

class Error extends React.Component {

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

  render() {
    let incidents = this.state.error.incidents;
    return (
      <Layout>
        <div className="row">
          <div className="col-xs-12">
            <Link to="/">≪ Back</Link>
          </div>
        </div>
        <div className="row">
          <span>Last occurance: {incidents && incidents[0] && incidents[0].timestamp}</span>
          <pre>
            {this.state.error.message}
          </pre>
        </div>
      </Layout>
    );
  }
}

export default Error;
