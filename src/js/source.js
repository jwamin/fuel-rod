var React = require("react"),
    ReactDOM = require("react-dom");

var HelloWorld = React.createClass({

      getDefaultProps:function(){
        return {
          style:{
            color:"black",
            cursor:"pointer"
          }
        }
      },

      getInitialState:function(){
        return {
          style:this.props.style
        }
      },

      changeColor:function(){
        console.log("clicked")

        var newStyle = Object.assign({},this.state.style,{color:"orange"})
        this.setState({
          style:newStyle
        })

      },

      shouldComponentUpdate:function(nextProps, nextState){
        console.log(this.state,nextState)
        if(this.state.style.color!==nextState.style.color){
          console.log("not equal, updating")
          return true;
        } else {
          console.log("not not equal, not updating")
          return false;
        }
      },

      render:function(){
        var message = this.props.message || "hello, world";
        return (<div style={this.state.style} onClick={this.changeColor}>
                <h2>{message}</h2>
              <div>And a div tag for a laff</div>
                </div>)
    }
  })

ReactDOM.render(<HelloWorld/>,document.querySelector(".app-container"))
