import React, { Component } from 'react';

export default class Layout extends Component {

  search(event) {
    this.setState({search: $(event.target).val()});
  }

  render() {
    return (
      <div>
        <nav className="nav navbar-default">
          <div className="container-fluid">
            <div className="navbar-header">
              <a className="navbar-brand" href="javascript:void(0);">Flames</a>
            </div>
            <form className="navbar-form navbar-right" role="search">
              <div className="form-group">
                <input type="text" className="form-control" placeholder="Search"  onKeyDown={this.search.bind(this)} />
              </div>
            </form>
          </div>
        </nav>
        <main className="container-fluid" role="main">
          <div className="col-xs-12">
            {this.props.children}
          </div>
        </main>
      </div>
    );
  }
}
