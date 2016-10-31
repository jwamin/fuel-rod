var React = require("react"),
    ReactDOM = require("react-dom");

console.log("hello world");

var HelloWorld = React.createClass({
      render:function(){
        return (<div>
                <h2>Hello</h2>
                </div>)
    }
  })

ReactDOM.render(<HelloWorld/>,document.body)
