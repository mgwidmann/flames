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
    return (
      <Layout>
        <div className="row">
          <div className="col-xs-12">
            <Link to="/">≪ Back</Link>
          </div>
        </div>
        <div className="row">
          <span>Last occurance: {this.state.error.incidents[0] && this.state.error.incidents[0].timestamp}</span>
          <pre>
            {this.state.error.message}
          </pre>
        </div>
      </Layout>
    );
  }
}

export default Error;
