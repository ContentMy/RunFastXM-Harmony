export class PageEventBus {
  private static instance: PageEventBus;
  private events: Map<string, Array<(data?: undefined) => void>> = new Map();

  private constructor() {}

  public static getInstance(): PageEventBus {
    if (!PageEventBus.instance) {
      PageEventBus.instance = new PageEventBus();
    }
    return PageEventBus.instance;
  }

  public subscribe(event: string, callback: (data?: undefined) => void): void {
    if (!this.events.has(event)) {
      this.events.set(event, []);
    }
    this.events.get(event)?.push(callback);
  }

  public unsubscribe(event: string, callback: (data?: undefined) => void): void {
    if (!this.events.has(event)) return;
    const callbacks = this.events.get(event);
    if (callbacks) {
      this.events.set(event, callbacks.filter(cb => cb !== callback));
    }
  }

  public publish(event: string, data?: undefined): void {
    if (!this.events.has(event)) return;
    const callbacks = this.events.get(event);
    if (callbacks) {
      callbacks.forEach(callback => callback(data));
    }
  }
}
