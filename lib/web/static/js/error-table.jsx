import React from 'react';
import _ from 'underscore';
import ResolveButton from './resolve-button.jsx';
import FlipMove from 'react-flip-move';

class ErrorTable extends React.Component {

  constructor(props) {
    super(props);
    let channel = props.socket.channel("errors", {});
    channel.join()
      .receive("ok", resp => { })
      .receive("error", resp => { });
    channel.on('error', (error) => {
      var errors = _.clone(this.state.errors);
      var existingError = _.findWhere(errors, {id: error.id});
      if (existingError){
        existingError.count += 1;
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

  matchesSearch(error) {
    if (this.props.search && !this.state.loading) {
      if (error.message && error.message.includes(this.props.search) || error.file && error.file.includes(this.props.search)) {
        return error;
      }
      return false;
    } else {
      return error;
    }
  }

  removeError(error) {
    var errors = _.reject(this.state.errors, (e) => { return e.id == error.id });
    this.setState({errors: errors});
  }

  renderError(error) {
    let rowClick = ()=> { this.handleClick(error) };
    return (
      <div key={error.id} className={`${this.rowColor(error)} info-row error-row row`} onClick={rowClick}>
        <span className="col-xs-1 level"><span className={`label ${this.levelColor(error)}`}>{error.level}</span></span>
        <span className="col-xs-5 message">{error.message}</span>
        <span className="col-xs-3 file">{this.renderFileInfo(error)}</span>
        <span className="col-xs-1 count">{error.count}</span>
        <span className="col-xs-2 resolve">
          <ResolveButton error={error} removeError={()=> { this.removeError(error) } } />
        </span>
      </div>
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
      <div id="errors" className="table table-stripped table-hover">
        <FlipMove enterAnimation="fade" leaveAnimation="fade" staggerDelayBy={50} duration={500} >
          {_.filter(this.state.errors, this.matchesSearch.bind(this)).map(this.renderError.bind(this))}
        </FlipMove>
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
