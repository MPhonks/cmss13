/**
 * @file
 * @copyright 2020 Aleksej Komarov
 * @license MIT
 */

import { KEY_BACKSPACE, KEY_F10, KEY_F11, KEY_F12 } from 'common/keycodes';
import type { AnyAction, Middleware } from 'common/redux';
import { globalEvents } from 'tgui/events';
import { acquireHotKey } from 'tgui/hotkeys';

import {
  openExternalBrowser,
  toggleDebugLayout,
  toggleKitchenSink,
} from './actions';

// prettier-ignore
const relayedTypes = [
  'backend/update',
  'chat/message',
];

export const debugMiddleware: Middleware = (store) => {
  acquireHotKey(KEY_F11);
  acquireHotKey(KEY_F12);
  globalEvents.on('keydown', (key) => {
    if (key.code === KEY_F11) {
      store.dispatch(toggleDebugLayout() as any);
    }
    if (key.code === KEY_F12) {
      store.dispatch(toggleKitchenSink() as any);
    }
    if (key.ctrl && key.alt && key.code === KEY_BACKSPACE) {
      // NOTE: We need to call this in a timeout, because we need a clean
      // stack in order for this to be a fatal error.
      setTimeout(() => {
        // prettier-ignore
        throw new Error(
          'OOPSIE WOOPSIE!! UwU We made a fucky wucky!! A wittle'
          + ' fucko boingo! The code monkeys at our headquarters are'
          + ' working VEWY HAWD to fix this!');
      });
    }
  });
  return (next) => (action) => next(action);
};

export const relayMiddleware: Middleware = (store) => {
  const devServer = require('tgui-dev-server/link/client.cjs');
  const externalBrowser = location.search === '?external';
  if (externalBrowser) {
    devServer.subscribe((msg) => {
      const { type, payload } = msg;
      if (type === 'relay' && payload.windowId === Byond.windowId) {
        store.dispatch({
          ...payload.action,
          relayed: true,
        });
      }
    });
  } else {
    acquireHotKey(KEY_F10);
    globalEvents.on('keydown', (key) => {
      if (key === KEY_F10) {
        store.dispatch(openExternalBrowser() as any);
      }
    });
  }
  return (next) => (action) => {
    const { type, payload, relayed } = action as AnyAction;
    if (type === openExternalBrowser.type) {
      window.open(location.href + '?external', '_blank');
      return;
    }
    if (relayedTypes.includes(type) && !relayed && !externalBrowser) {
      devServer.sendMessage({
        type: 'relay',
        payload: {
          windowId: Byond.windowId,
          action,
        },
      });
    }
    return next(action);
  };
};
