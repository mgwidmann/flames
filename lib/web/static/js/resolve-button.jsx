import React from 'react';
import {Button, Modal} from 'react-bootstrap';

export default class ResolveButton extends React.Component {

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
          <Button onClick={this.close}>Close</Button>
          <Button bsStyle="danger" onClick={resolve}>Resolve</Button>
        </Modal.Footer>
      </Modal>
    );
  }

  render() {
    return (
      <div>
        <Button bsStyle="danger" className="btn-xs" onClick={this.resolveClick.bind(this)}>Resolve</Button>
        {this.renderModal()}
      </div>
    );
  }
}
