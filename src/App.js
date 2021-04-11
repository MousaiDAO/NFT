import logo from './logo.jpg';
import './App.css';

function App() {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <h1>
          MOUSAI
        </h1>
        <h2>NFT Royalty</h2>
        <a>
          
        </a>
        <p>Create Your Token</p>
          <form>
            <label>
             Name:
           <input type="text" name="name" />
            </label>
           <input type="submit" value="Submit" />
          </form>
          <form>
            <label>
              Wallet Address:
            <input type="text" name="name" />
            </label>
             <input type="submit" value="Submit" />
          </form>
          <form>
            <label>
             Token Asset(art,music):
             <input type="text" name="name" />
            </label>
            <input type="submit" value="Submit" />
          </form>
      </header>
    </div>
  );
}

export default App;
