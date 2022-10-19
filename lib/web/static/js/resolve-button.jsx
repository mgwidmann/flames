import React, { Component } from 'react';
import {Button, Modal} from 'react-bootstrap';
import { incidentTimestamp } from './helper.js';

export default class ResolveButton extends Component {

  constructor(props) {
    super(props);
    this.state = {showModal: false};
    this.close = this.close.bind(this);
    this.renderBody = this.renderBody.bind(this);
  }

  resolveClick(event) {
    this.setState({showModal: true});
    event.stopPropagation();
  }

  resolve(error) {
    $.ajax({
      url: `${window.location.pathname}/api/errors/${error.id}`,
      dataType: 'json',
      method: 'DELETE'
    }).done(()=> {
      this.props.removeError();
      this.close();
    });
  }

  close() {
    this.setState({showModal: false});
  }

  renderBody() {
    if (this.props.simple) {
      return null;
    } else {
      return (
        <pre>
          {this.props.error.message}
        </pre>
      );
    }
  }

  renderModal() {
    let resolve = ()=> { this.resolve(this.props.error) };
    const { incidents, module, line, file } = this.props.error;
    const func = this.props.error['function'];
    let moduleLine;
    if(module && func && file && line) {
      moduleLine = (
        <span>
          <h5>{func}</h5>
          <h6>{file}:{line}</h6>
        </span>
      )
    }
    return (
      <Modal bsSize={this.props.simple ? "md" : "lg"} show={this.state.showModal} onHide={this.close}>
        <Modal.Header closeButton>
          <Modal.Title>Resolve Error</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <div>Are you sure you want to resolve this error?</div>
          Last occurance: {incidentTimestamp(incidents && incidents[0] && incidents[0].timestamp || this.props.error.timestamp)}
          {moduleLine}
          {this.renderBody()}
        </Modal.Body>
        <Modal.Footer>
          <button className="btn" onClick={this.close}>Close</button>
          <button className="btn btn-danger" onClick={resolve}>Resolve</button>
        </Modal.Footer>
      </Modal>
    );
  }

  render() {
    let { className } = this.props;
    return (
      <div>
        <button className={(className || "btn-xs") + " btn-danger"} onClick={this.resolveClick.bind(this)}>Resolve</button>
        {this.renderModal()}
      </div>
    );
  }
}
