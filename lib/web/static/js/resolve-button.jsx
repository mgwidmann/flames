import React, { Component } from 'react';
import {Button, Modal} from 'react-bootstrap';

export default class ResolveButton extends Component {

  constructor(props) {
    super(props);
    this.state = {showModal: false};
    this.close = this.close.bind(this);
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

  renderModal() {
    let resolve = ()=> { this.resolve(this.props.error) };
    return (
      <Modal show={this.state.showModal} onHide={this.close}>
        <Modal.Header closeButton>
          <Modal.Title>Resolve Error</Modal.Title>
        </Modal.Header>
        <Modal.Body>
          <span>Are you sure you want to resolve this error?</span>
          <pre>
            {this.props.error.message}
          </pre>
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
