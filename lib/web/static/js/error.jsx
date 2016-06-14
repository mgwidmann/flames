import React from 'react';
import {Link} from 'react-router';

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
      <div>
        <div className="row">
          <div className="col-xs-12">
            <Link to="/">≪ Back</Link>
          </div>
        </div>
        <div className="row">
          <pre>
            {this.state.error.message}
          </pre>
        </div>
      </div>
    );
  }
}

export default Error;
