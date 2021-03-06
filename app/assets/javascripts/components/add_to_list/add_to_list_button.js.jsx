var AddToListButton = React.createClass({
  propTypes: {
    id: React.PropTypes.number,
    type: React.PropTypes.string,
    name: React.PropTypes.string,
    loader_image: React.PropTypes.string,
    list_count: React.PropTypes.number,
    action: React.PropTypes.string,
    autocomplete_path: React.PropTypes.string,
    authenticity_token: React.PropTypes.string,
    button_class: React.PropTypes.string,
    logged_in: React.PropTypes.bool,
    options: React.PropTypes.array
  },

  getInitialState: function() {
    return {
      showModal: false,
      listCount: this.props.list_count
    }
  },

  updateListCount: function(newValue) {
    this.setState({ listCount: newValue })
  },

  toggleModal: function(e) {
    e.preventDefault();
    this.setState({ showModal: !this.state.showModal }, () =>{
      if (this.state.showModal) {
        $('body').addClass('no-scroll');
      } else {
        $('body').removeClass('no-scroll');
      }
    });
  },

  render: function() {
    var modal = null;
    if (this.state.showModal) {
      modal = (
        <AddToListModal id={this.props.id}
                        type={this.props.type}
                        name={this.props.name}
                        action={this.props.action}
                        loaderImage={this.props.loader_image}
                        autocompletePath={this.props.autocomplete_path}
                        authenticityToken={this.props.authenticity_token}
                        toggleModal={this.toggleModal}
                        updateListCount={this.updateListCount}
                        loggedIn={this.props.logged_in}
                        options={this.props.options} />
      )
    }

    return (
      <div>
        <a className={"btn-add-to-list btn " + this.props.button_class} onClick={this.toggleModal}>
          Add to a list ({this.state.listCount})
        </a>
        {modal}
      </div>
    );
  }
});
