'use babel';

import CrazyFormatterView from './crazy-formatter-view';
import { CompositeDisposable } from 'atom';

export default {

  crazyFormatterView: null,
  modalPanel: null,
  subscriptions: null,

  activate(state) {
    this.crazyFormatterView = new CrazyFormatterView(state.crazyFormatterViewState);
    this.modalPanel = atom.workspace.addModalPanel({
      item: this.crazyFormatterView.getElement(),
      visible: false
    });

    // Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    this.subscriptions = new CompositeDisposable();

    // Register command that toggles this view
    this.subscriptions.add(atom.commands.add('atom-workspace', {
      'crazy-formatter:toggle': () => this.toggle()
    }));
  },

  deactivate() {
    this.modalPanel.destroy();
    this.subscriptions.dispose();
    this.crazyFormatterView.destroy();
  },

  serialize() {
    return {
      crazyFormatterViewState: this.crazyFormatterView.serialize()
    };
  },

  toggle() {
    console.log('CrazyFormatter was toggled!');
    return (
      this.modalPanel.isVisible() ?
      this.modalPanel.hide() :
      this.modalPanel.show()
    );
  }

};
