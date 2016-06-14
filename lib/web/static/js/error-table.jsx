import React from 'react';
import _ from 'underscore';

class ErrorTable extends React.Component {

  constructor(props) {
    super(props);
    let channel = props.socket.channel("errors", {});
    channel.join()
      .receive("ok", resp => { })
      .receive("error", resp => { });
    channel.on('error', (error) => {
      var errors = _.clone(this.state.errors);
      var error = _.findWhere(errors, {id: error.id});
      if (error){
        error.count += 1;
        this.setState({errors: errors});
      } else {
        this.setState({errors: [error].concat(errors)});
      }
    });
    this.state = {channel: channel, errors: [], loading: true};
    $.get({
      url: `${window.location.pathname}/api/errors`, dataType: 'json'
    }).done((data)=> {
      this.setState({errors: data, loading: false});
    }).fail(()=> {
      this.setState({loading: false});
    });
  }

  rowColor(error) {
    return error.level == "warn" ? "warning" : '';
  }

  levelColor(error) {
    return error.level == "warn" ? "label-warning" : "label-danger";
  }

  handleClick(error) {
    this.props.router.push(`/errors/${error.id}`);
  }

  renderError(error) {
    let onClick = ()=> { this.handleClick(error) };
    return (
      <tr key={error.id} className={`${this.rowColor(error)} error-row`} onClick={onClick}>
        <td className="level"><span className={`label ${this.levelColor(error)}`}>{error.level}</span></td>
        <td className="message">{error.message}</td>
        <td className="file">{this.renderFileInfo(error)}</td>
        <td className="count">{error.count}</td>
      </tr>
    );
  }

  renderFileInfo(error) {
    if (error.file && error.function) {
      return <span>{`${error.file}:${error.function}`}</span>;
    } else {
      return (
        <span className="text-muted">
          (No file information)
        </span>
      );
    }
  }

  renderEmpty() {
    return (
      <div className="jumbotron text-center info-row">
        <h1>
          🎉🎈🎊&nbsp;Hooray!&nbsp;🎊🎈🎉
        </h1>
        <h4>
          Your application is error free!
        </h4>
      </div>
    );
  }

  renderErrors() {
    return (
      <div>
        <table id="errors" className="table table-stripped table-hover">
          <tbody>
            {this.state.errors.map(this.renderError.bind(this))}
          </tbody>
        </table>
      </div>
    );
  }

  renderLoading(){
    return (
      <div className="jumbotron text-center info-row">
        <h1>🕒&nbsp;Loading...</h1>
      </div>
    );
  }

  render() {
    if (this.state.loading){
      return this.renderLoading();
    } else if (this.state.errors.length == 0) {
      return this.renderEmpty();
    } else {
      return this.renderErrors();
    }
  }

}

export default ErrorTable;
