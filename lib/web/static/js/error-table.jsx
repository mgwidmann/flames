import React, { Component } from 'react';
import _ from 'underscore';
import ResolveButton from './resolve-button.jsx';
import FlipMove from 'react-flip-move';

class ErrorTable extends Component {

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
    this.state = {channel: channel, errors: [], loading: true, selected: []};
    this.loadErrors()
  }

  loadErrors() {
    this.setState({loading: true});
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

  resolveAll() {
    $.ajax({
      url: `${window.location.pathname}/api/errors`,
      dataType: 'json',
      method: 'DELETE',
      data: {
        ids: this.state.selected
      }
    }).done(()=> {
      this.setState({ selected: [] });
      this.loadErrors();
    });
  }

  selectError(event, error) {
    event.stopPropagation();
    if (event.target.checked) {
      this.setState({selected: this.state.selected.concat(error.id) });
    } else {
      this.setState({selected: _.reject(this.state.selected, (id) => { id == error.id })});
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
        <span className="col-xs-1 resolve">
          <ResolveButton error={error} removeError={()=> { this.removeError(error) } } />
        </span>
        <span className="col-xs-1">
          <input type="checkbox" onClick={(e) => { this.selectError(e, error) }}/>
        </span>
      </div>
    );
  }

  renderFileInfo(error) {
    if (error.file && error.function) {
      return <span>{`${error.file}:${error.line}`}</span>;
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
        <div className="row info-row">
          <div className="col-xs-1">
            <span className="table-header">Level</span>
          </div>
          <div className="col-xs-5">
            <span className="table-header">Message</span>
          </div>
          <div className="col-xs-3">
            <span className="table-header">File</span>
          </div>
          <div className="col-xs-1">
            <span className="table-header">Count</span>
          </div>
          <div className='col-xs-2'>
            <div className="pull-right">
              <button onClick={this.resolveAll.bind(this)} className={`btn btn-danger ${_.isEmpty(this.state.selected) ? 'disabled' : ''}`}>Resolve All</button>
            </div>
          </div>
        </div>
        <div id="errors" className="table table-stripped table-hover">
          <FlipMove enterAnimation="fade" leaveAnimation="fade" staggerDelayBy={50} duration={500} >
            {_.filter(this.state.errors, this.matchesSearch.bind(this)).map(this.renderError.bind(this))}
          </FlipMove>
        </div>
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
    let inner = null;
    if (this.state.loading){
      inner = this.renderLoading();
    } else if (this.state.errors.length == 0) {
      inner = this.renderEmpty();
    } else {
      inner = this.renderErrors();
    }
    return (
      <div className="row">
        <div className="col-xs-12">
          {inner}
        </div>
      </div>
    )
  }

}

export default ErrorTable;
